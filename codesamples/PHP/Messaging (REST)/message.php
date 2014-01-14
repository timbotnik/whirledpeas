<?php defined('SYSPATH') or die('No direct script access.');

//
//  Model_Message
//
//  Created by Tim Hingston on 1/13/12.
//  Copyright (c) 2013 Tim Hingston. All rights reserved.
//


/** 
 * A model-layer DAO for chat messages
 */

class Model_Message extends Model_Base {
  protected static $tableName = 'messages';
  protected static $maskUpdateFields = array('fromUserId','toUserId', 'message', 'createdAt');

  public $id;
  public $fromUserId;
  public $toUserId;
  public $unread;
  public $body;
  public $createdAt;
  public $updatedAt;

	// transient fields
	public $messageCount;
  
  public static function validateCreate($data) {
    return Validate::factory($data)
    ->filter(true, 'trim')
    ->rule('fromUserId', 'not_empty')
    ->rule('fromUserId', 'numeric')
		->rule('fromEmoteId', 'numeric')
    ->rule('toUserId', 'not_empty')
    ->rule('toUserId', 'numeric'))
    ->rule('unread', 'numeric')
    ->rule('body', 'not_empty')
    ->filter('body', 'Model_Base::textFilter')
    ->rule('body', 'max_length', array(10000));
  }
   
  public static function validateUpdate($data) {
    return Validate::factory($data)
    ->rule('fromUserId', 'numeric')
		->rule('fromEmoteId', 'numeric')
    ->rule('toUserId', 'numeric')
    ->rule('unread', 'numeric')
    ->filter('body', 'Model_Base::textFilter')
    ->rule('body', 'max_length', array(10000));
  }
   
  public function beforeCreate() {
    $this->check(array(get_called_class(), 'validateCreate'));
  }

  public function beforeUpdate() {
    $this->check(array(get_called_class(), 'validateUpdate'));
  }

	public static function markIdsAsRead($userId, $messageIds, $read = true) {
		$query = DB::update(static::$tableName)
			->set(array('unread' => $read ? 0 : 1))
			->where('toUserId', '=', $userId)
			->where('id', 'IN', $messageIds);
		return $query->execute();
	}

	public static function markMessagesAsRead($messages, $read = true) {
	  $ids = array();
	  foreach ($messages as $m) {
	    $ids[] = $m->id;
	  }
    $query = DB::update(static::$tableName)
			->set(array('unread' => $read ? 0 : 1))
			->where('id', 'IN', $ids);
		return $query->execute();
	}
	
	public static function markAllAsReadForUsers($toUserId, $fromUserId) {
		$query = DB::update(static::$tableName)
			->set(array('unread' => '0'))
			->where('toUserId', '=', $toUserId)
			->where('fromUserId', '=', $fromUserId)
			->where('unread', '=', '1');
		$results = $query->execute();
		return $results;
	}
	
	public static function getInbox($userId, $offset = 0, $limit = 10) {
		$query = DB::query(Database::SELECT,
			"SELECT u.nickname, up.gender, up.avatarUrl,
							msg.id AS msgId, msg.fromUserId, msg.toUserId, msg.unread, msg.body, msg.createdAt,
							(SELECT COUNT(1) FROM messages WHERE toUserId = :userId AND fromUserId = u.id AND unread='1') as unread
							FROM messages msg
							INNER JOIN
							 (SELECT userId, dir, MAX(createdAt) as createdAt FROM
							 	((SELECT fromUserId as userId, 'in' as dir, MAX(createdAt) as createdAt FROM messages WHERE toUserId = :userId GROUP BY fromUserId)
									UNION
									(SELECT toUserId as userId, 'out' as dir, MAX(createdAt) as createdAt FROM messages WHERE fromUserId = :userId GROUP BY toUserId)) umsg
								GROUP BY userId
							  ) amsg
							ON (msg.createdAt = amsg.createdAt AND (msg.fromUserId = amsg.userId OR msg.toUserId = amsg.userId))
							INNER JOIN users u ON u.id = amsg.userId
							INNER JOIN userProfiles up ON u.id = up.userId
							INNER JOIN contacts c ON (c.userId = :userId AND c.contactUserId = u.id AND c.status = 'accepted')
							ORDER BY msg.createdAt DESC
							LIMIT :offset, :limit")
			->param(':userId', $userId)
			->param(':offset', $offset)
			->param(':limit', $limit);
	  $results = $query->execute()->as_array();
		return $results;
	}
	
	public static function deleteAllWithUsers($toUserId, $fromUserId) {
		$query = DB::delete(static::$tableName)
			->where_open()
			->or_where_open()
				->where('toUserId', '=', $toUserId)
				->where('fromUserId', '=', $fromUserId)
			->or_where_close()
			->or_where_open()
				->where('toUserId', '=', $fromUserId)
				->where('fromUserId', '=', $toUserId)
			->or_where_close()
			->where_close();
		$results = $query->execute();
	}
	
	public static function listFiltered($userId, $filters) {
		if (isset($filters['count'])) {
			$query = DB::select($filters['count'], array('COUNT("id")', 'messageCount'))
				->from(static::$tableName)
				->group_by($filters['count']);
		}
		else {
			$query = DB::select()->from(static::$tableName);
		}	
		if (isset($filters['with'])) {
			$query->where_open()
				->or_where_open()
					->where('toUserId', '=', $filters['with'])
					->where('fromUserId', '=', $userId)
				->or_where_close()
				->or_where_open()
					->where('toUserId', '=', $userId)
					->where('fromUserId', '=', $filters['with'])
				->or_where_close()
			->where_close();
		}
		else if (isset($filters['direction'])) {
			switch ($filters['direction']) {
				case 'to':
					$query->where('toUserId', '=', $userId);
					break;
				case 'from':
					$query->where('fromUserId', '=', $userId);
					break;
				case 'both':
				default:
					$query->where_open()
						->or_where('fromUserId', '=', $userId)
						->or_where('toUserId', '=', $userId)
					->where_close();
				break;
			}
		}
		else {
			$query->where_open()
				->or_where('fromUserId', '=', $userId)
				->or_where('toUserId', '=', $userId)
			->where_close();
		}
		if (isset($filters['unread'])) {
			$query->where('unread', '=', $filters['unread']);
		}
		if (isset($filters['start'])) {
			$query->where('createdAt', '>=', $filters['start']);
		}
		if (isset($filters['end'])) {
			$query->where('createdAt', '<=', $filters['end']);
		}
		if (isset($filters['limit'])) {
			$query->limit($filters['limit']);
		}
		if (isset($filters['offset'])) {
			$query->offset($filters['offset']);
		}
		if (isset($filters['asc']))
		  $query->order_by('createdAt','asc');
		else
		  $query->order_by('createdAt','desc');
		$messages = static::getResults($query);
		return $messages;
	}
	
	public static function getUnreadCount($toUserId) {
		$count = Model_Message::count(array('toUserId' => $toUserId, 'unread' => 1));
		return $count;
	}
	
	public function getNotifyList($action, $eventId) {
		$notifyUser = Model_User::load($this->toUserId);
		return array($notifyUser);
	}
}
