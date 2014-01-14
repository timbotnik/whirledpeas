<?php defined('SYSPATH') or die('No direct script access.');

//
//  Controller_Messages
//
//  Created by Tim Hingston on 1/13/12.
//  Copyright (c) 2013 Tim Hingston. All rights reserved.
//

/** 
 * A web service controller for chat messages
 */
class Controller_Messages extends Controller_AuthApi {
  protected $accessMap = array(
    'index'        => array(App_Access::ANY),
    'inbox'        => array(App_Access::ANY),
    'create'	   => array(App_Access::USER, App_Access::ADMIN),
		'delete'		=> array(App_Access::USER, App_Access::ADMIN),
		'deleteAll'		=> array(App_Access::USER, App_Access::ADMIN),
    'markAsRead' => array(App_Access::USER, App_Access::ADMIN)
  );
  
  const MAX_LIMIT = 50;
  const MAX_BATCH_SIZE = 100;
  
  /** 
   * GET method which returns an array of messages, filtered using GET params.
   * @param with Filter messages between current user and a contact
   * @param direction Can be 'to' or 'from'. Use 'to' for received messages, 'from' for sent messages. Defaults to both.
   * @param unread Can be 0 or 1.  Use 1 for unread, 0 for already read messages. Defaults to both.
   * @param start A timestamp to mark start of message listing
   * @param end A timestamp to end message listing
   * @param offset A pagination offset into the message list
   * @param limit A pagination limit for messages returned (50 max)
   */
  public function action_index() {
    try {
      $userId = App_Access::getCurrentUserId();
			if (!isset($_GET['with'])) {
				$this->apiFail(I18N::get('errors.nocontact'));
				return;
			}
			$c1 = Model_Contact::find(array(
			  'userId' => $userId, 
			  'contactUserId' => $_GET['with'], 
			  'status' => 'accepted'));
      if (!$c1) {
        $this->apiFail(I18N::get('errors.nocontact'));
        return;
      }
			$offset = 0;
			$limit = MAX_LIMIT;
			if (isset($_GET['offset']))
				$offset = intval($_GET['offset']);
			if (isset($_GET['limit']))
				$limit = min(static::MAX_LIMIT, intval($_GET['limit']));
			
			$messages = Model_Message::listFiltered($userId, array(
			  'with' => $c1->contactUserId, 
			  'offset' => $offset,
			  'limit' $limit);
			$updates = Model_Message::markMessagesAsRead($messages);
      $this->apiSuccess($messages);
    }
    catch (Exception $e) {
      $this->apiException($e);
    }
  }

  /** 
   * GET method which returns an array of the most recent message between the user and each contact.
   */
  public function action_inbox() {
    try {
      $userId = App_Access::getCurrentUserId();
			$messages = Model_Message::getInbox($userId);
      $this->apiSuccess($messages);
    }
    catch (Exception $e) {
      $this->apiException($e);
    }
  }

  /** 
   * POST method to create a new message.  Recipients will receive APNS notifications for new messages.
   * @param toUserId The user ID of the recipient
   * @param body The body of the message
   */
  public function action_create() {
  	try {
      $toId = $_POST['toUserId'];
      $userId = App_Access::getCurrentUserId();
      $c1 = Model_Contact::find(array('userId' => $userId, 'contactUserId' => $toId, 'status' => 'accepted'));
      if (!$c1) {
        $this->apiFail(I18N::get('errors.nocontact'));
        return;
      }
			$_POST['fromUserId'] = $userId;
			$message = Model_Message::instance($_POST)->create();
			$toUser = Model_User::load($toId);
			App_Notifier::instance()->sendBadgeUpdate($toUser->apnsToken, $toUser->getBadgeCount());
      $this->apiSuccess($message->toArray());
    }
    catch (Exception $e) {
      $this->apiException($e);
    }
	}
	
  /** 
   * POST method to mark a set of messages as 'read'.
   * @param messageIds A JSON array of message IDs (MAX 100).
   */
	public function action_markAsRead() {
		try {
			$messages = new ResultSet();
      if (isset($_POST['messageIds'])) {
				$ids = json_decode($_POST['messageIds']);
				if (!$ids) {
				  $this->apiFail(I18N::get('errors.message.notfound'));
				  return;
				}
				if (count($ids) > static::MAX_BATCH_SIZE) {
				  $this->apiFail(I18N::get('errors.message.batchSize'));
				  return;
				}
				$messages = Model_Message::markIdsAsRead(App_Access::getCurrentUserId(), $ids);
			}
	    $this->apiSuccess(array());
    }
    catch (Exception $e) {
      $this->apiException($e);
    }
	}
	
  /** 
   * DELETE method to delete a message.
   * @param id The id of the message to delete.
   */
	public function action_delete() {
		try {
			$id = $this->getIdParam();
			$mIn = Model_Message::find(array('id' => $id, 'toUserId' => App_Access::getCurrentUserId()));
			if ($mIn) {
				Model_Message::delete($mIn->id);
				$this->apiSuccess($mIn->id);
			}
			else {
				$mOut = Model_Message::find(array('id' => $id, 'fromUserId' => App_Access::getCurrentUserId()));
				if ($mOut) {
					Model_Message::delete($mOut->id);
					$this->apiSuccess($mOut->id);
				}	
				else {
					$this->apiFail(I18N::get('errors.message.notfound'));
				}
			}
    }
    catch (Exception $e) {
      $this->apiException($e);
    }
	}
	
	/** 
   * POST method to delete all messages with a contact.
   * @param with The contactId whom messages will be deleted for.
   */
	public function action_deleteAll() {
		try {
			if (!isset($_POST['with'])) {
				$this->apiFail(I18N::get('errors.message.notfound'));
				return;
			}
			$withId = $_POST['with'];
			$result = Model_Message::deleteAllWithUsers(App_Access::getCurrentUserId(), $withId);
			$this->apiSuccess($result);
    }
    catch (Exception $e) {
      $this->apiException($e);
    }
	}
}
