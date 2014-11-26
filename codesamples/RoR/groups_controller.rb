module Api
  module V1
    class GroupsController < ApiAuthController
    include ApiExamples

      ## PARAMETER DOCUMENTATION
      resource_description do
        short "APIs related to Groups"
        formats ['json']
        resource_id "groups"
      end

      def_param_group :create_group do
        param :group, Hash, :required => true do
          param :name, String, "Name of the group", :required => true
          param :description, String, "Description of the group"
          param :latitude, String, "GPS latitude of the groups's location"
          param :longitude, String, "GPS longitude of the group's location"
          param :categories, Array, "List of categories the group is associated with", of: String
          param :avatar, File, "User's avatar image data"
        end
      end

      def_param_group :update_group do
        param :user, Hash, :required => true do
          param :id, Integer, :desc => "Group ID", :required => true
          param :name, String, "Name of the group", :required => true
          param :description, String, "Description of the group"
          param :latitude, String, "GPS latitude of the groups's location"
          param :longitude, String, "GPS longitude of the group's location"
          param :categories, Array, "List of categories the group is associated with", of: String
          param :avatar, File, "User's avatar image data"
        end
      end

      ## END PARAMETER DOCUMENTATION
     

      api :POST, "/groups", "Create a group"
      desc "Automatically adds the creator as a follower."
      param_group :create_group
      example ApiExamples.example_exchange("group_create")
      
      def create
        group_params = new_group_params
        if group_params.has_key?(:avatar)
          avatar = Avatar.new({image: group_params[:avatar]})
          avatar.save!
          group_params[:avatar] = avatar
        end
        
        cat_names = []
        if group_params.has_key?(:categories)
          cat_names = group_params[:categories]
          group_params.delete(:categories)
        end

        group_params[:admin_user] = @current_user
        group_params[:user_count] = 1
        group = Group.new(group_params)
        
        categories = []
        cat_names.each do |cat_name| 
          cat = GroupCategory.find_by(name: cat_name)
          categories << cat if cat
        end
        group.group_categories = categories
        group.save!
        group.followers << @current_user

        api_success({ group: _group(group) })
      end

      

      api :PATCH, "/groups/:groupId", "Update a group"
      param :groupId, Integer, "The group ID to update", :required => true
      param_group :update_group
      example ApiExamples.example_exchange("group_update")
      
      def update
        check_write_access
        group_params = update_group_params
        if group_params.has_key?(:avatar)
          avatar = Avatar.new({image: group_params[:avatar]})
          avatar.save!
          group_params[:avatar] = avatar
        end

        if group_params.has_key?(:categories)
          cat_names = group_params[:categories]
          group_params.delete(:categories)

          categories = []
          cat_names.each do |cat_name| 
            cat = GroupCategory.find_by(name: cat_name)
            categories << cat if cat
          end
          @current_group.group_categories = categories;
        end
        @current_group.assign_attributes(group_params)
        @current_group.save!

        api_success({ group: _group(@current_group) })
      end



      api :GET, "/groups/:groupId", "Get group details"
      param :groupId, Integer, "The group ID of the group to view", :required => true
      #example ApiExamples.example_response("group")

      def show
        check_read_access
        api_success({ group: _group(@current_group) })
      end


      
      api :GET, "/groups/filter", "Filter groups based on popularity, location, following, category, and search text"
      param :scope, String, "One of: 
        [popularity] Order by popularity in descending order
        [proximity] Order by nearest to location in descending order.  Defaults to the user's stored location, however can be overridden by setting the location parameter. NOTE: does not yet support chaining other filters (search_text, categories, pagination)
        [following] Filter to groups the user is following", :required => true
      param :categories, Array, "List of categories to filter by", of: String
      param :search_text, String, "Search text to filter by"
      param :location, Hash do
          param :latitude, String, "GPS latitude of the location to search"
          param :longitude, String, "GPS longitude of the location to search"
          param :distance, String, "Distance limit of search, default is 100km"
      end
      param_group :paginated, ApiController
      #example ApiExamples.example_response("group")

      def filter
        scope = params.require(:scope)
        filter_query = case scope
          when "popularity"
            Group.by_popularity
          when "proximity"
            latitude = params.has_key?(:location) ? params[:location][:latitude] : @current_user.latitude
            longitude = params.has_key?(:location) ? params[:location][:longitude] : @current_user.longitude
            api_fail("No location set") if !latitude || !longitude
            distance = params.has_key?(:location) && params[:location].has_key?(:distance) ? params[:location][:distance] : 100
            #Group.by_location(latitude, longitude, distance)
            Group.within(distance, :origin => [latitude,longitude])
          when "following"
            Group.by_follower(@current_user)
          else
            api_fail("Invalid scope")
          end

        if scope == "proximity"
          filter_query = filter_query.by_categories(params[:categories]) if params.has_key?(:categories)
          filter_query = filter_query.by_name(params[:search_text]) if params.has_key?(:search_text)
          filter_query = filter_query.by_distance(params[:distance]) if params.has_key?(:distance)
          groups = paginate_query(filter_query)
        else
          filter_query = filter_query.by_categories(params[:categories]) if params.has_key?(:categories)
          filter_query = filter_query.by_name(params[:search_text]) if params.has_key?(:search_text)
          groups = paginate_query(filter_query)
        end
        api_success({ groups: _groups(groups) })
      end
      

      
      api :GET, "/groups/:groupId/followers", "Get group followers"
      param :groupId, Integer, "The group ID of the group to list followers of", :required => true
      param_group :paginated, ApiController
      example ApiExamples.example_response("followers")

      def followers
        check_read_access
        followers = paginate_query(@current_group.followers)
        api_success({ users: _users(followers) })
      end



      api :POST, "/groups/:groupId/follow", "Follow a group"
      param :groupId, Integer, "The group ID of the group to follow", :required => true
      example ApiExamples.example_response("group_follow")

      def follow
        check_read_access
        @current_group.followers << @current_user
        @current_group.increment!("user_count")
        api_success({ group: _group(@current_group) })
      end



      api :POST, "/groups/:groupId/unfollow", "Unfollow a group"
      param :groupId, Integer, "The group ID of the group to unfollow", :required => true
      example ApiExamples.example_response("group_unfollow")

      def unfollow
        check_read_access
        @current_group.followers.delete(@current_user)
        @current_group.decrement!("user_count")
        api_success({ group: _group(@current_group) })
      end

    private

      def new_group_params
        params.require(:group).permit(
          :name, 
          :description, 
          :latitude, 
          :longitude,
          :avatar,
          categories: [] # Ruby requires us to put the categories array at the end of the list here.
          ) 
      end

      def update_group_params
        params.require(:group).permit(
          :id,
          :name, 
          :description, 
          :latitude, 
          :longitude,
          :avatar,
          categories: [] # Ruby requires us to put the categories array at the end of the list here.
          )
      end

      def check_read_access
        @current_group = Group.find(params.require(:id))
        api_fail("Group does not exist", nil, :not_found) if !@current_group
      end

      def check_write_access
        check_read_access
        api_fail("You cannot modify this group", nil, :unauthorized) if @current_group.admin_user_id != @current_user.id
      end
    end
  end
end
