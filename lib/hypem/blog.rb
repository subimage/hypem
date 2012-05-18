require 'hashie'

module Hypem
  class Blog
    attr_reader :blog_image, :blog_image_small, :first_posted,
                :followers, :last_posted, :site_name, :site_url,
                :total_tracks, :id

    def initialize(*args)
      if args.count == 1
        @id = args.first.is_a?(Integer) ? args.first : args.first.to_i
      end
    end

    def get_info
      unless @has_info
        response = Request.new("/api/get_site_info?siteid=#{@id}").get.response.body
        update_from_response(response)
        @has_info = true
      end
      return self
    end

    def update_from_response(rsp)
      @blog_image ||= rsp['blog_image']
      @blog_image_small ||= rsp['blog_image_small']
      @followers ||= rsp['followers']
      @id ||= rsp['siteid']
      @site_name ||= rsp['sitename']
      @site_url ||= rsp['siteurl']
      @total_tracks ||= rsp['total_tracks']

      # only from get_info
      @first_posted ||= Time.at(rsp['first_posted']) unless rsp['first_posted'].nil?
      @last_posted ||= Time.at(rsp['last_posted']) unless rsp['last_posted'].nil?

    end
  end
end