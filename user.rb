#coding: utf-8
require 'mongorilla'
require File.expand_path("./current_book_info", File.dirname(__FILE__))
require File.expand_path("./bookshelf", File.dirname(__FILE__))
require File.expand_path("./reading_log", File.dirname(__FILE__))
class User
  UserFields = [:_id,:name,:total_read_page_num,:current_book_info_rec]
  include Mongorilla::Document

  def self.build(name)
    User.create( :name => name,
              :total_read_page_num => 0,
              :current_book_info_rec => {}
              )
  end

  def current_book_info
    @current_book_info ||= CurrentBookInfo.new(self,self.current_book_info_rec)
  end

  def current_reading_logs
    ReadingLog.find({:user_id => self.id},{:sort => [["created_at","desc"]],:limit=>5})
  end

  def bookshelf
    return @bookshelf  if @bookshelf
    @bookshelf = Bookshelf.find_one("user_id" => self.id)
    unless @bookshelf
      @bookshelf = Bookshelf.build(self.id)
    end
    return @bookshelf
  end
end
