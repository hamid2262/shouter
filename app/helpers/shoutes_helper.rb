require "digest/md5"

module ShoutesHelper
	def gravatar user, size = 48
		digest = Digest::MD5.hexdigest(user.email)
		image_tag("http://gravatar.com/avatar/#{digest}?s=#{size}")
	end

	def shouterize text
		link_colon(link_hashtag( strip_tags(text) )).html_safe
	end

	private

	def link_colon text
	  text.gsub(/(\w+::\w+)/) { |match| link_to( match, hashtag_path($1) ) }
		# text.gsub(/(\w+ \# \w+)/) { |match| link_to( match, hashtag_path($1) ) }
	end
	def link_hashtag text
	  # text.gsub(/(\w+::\w+)/) { |match| link_to( match, hashtag_path($1) ) }
		text.gsub(/(\w+\#\w+)/) { |match| link_to( match, hashtag_path($1) ) }
	end	

end