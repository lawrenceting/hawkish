class Tracker < ActiveRecord::Base
	
	require 'rubygems'	
	require 'nokogiri'
	require 'open-uri'		
	
	has_many :updates 
	
	attr_writer :current_step

	validates_presence_of :url, :if => lambda { |o| o.current_step == "shipping" }
	validates_presence_of :nodes, :if => lambda { |o| o.current_step == "billing" }

	def current_step
	  @current_step || steps.first
	end

	def steps
	  %w[shipping billing confirmation]
	end

	def next_step
	  self.current_step = steps[steps.index(current_step)+1]
	end

	def previous_step
	  self.current_step = steps[steps.index(current_step)-1]
	end

	def first_step?
	  current_step == steps.first
	end

	def last_step?
	  current_step == steps.last
	end

	def all_valid?
	  steps.all? do |step|
		self.current_step = step
		valid?
	  end
	end
	
	def get_html
		@html = Nokogiri::HTML(open(self.url))
		@html = @html.css('html') #html tag + content in between 
		@html.search('.//title').remove
#		@html.search('.//script').remove
		@html.search('.//meta').remove
		@html.xpath('//comment()').remove
#		@html.search('.//style').remove
#		@html.search('.//link').remove
		
		@html.inner_html
	end	
	
	def self.test
		
		
	end
end
