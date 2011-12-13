#coding: utf-8
require 'mongorilla'
require File.expand_path("./book_info", File.dirname(__FILE__))
class Bookshelf
  BookshelfFields = [:_id,:user_id,:book_num,:book_info_records]
  include Mongorilla::Document

  alias save_orig save


  def self.build(user_id)
    Bookshelf.create( :user_id => user_id,
              :book_num => 0,
              :book_info_records => []
              )
  end

  def book_infos
    self.book_info_records.map{|r| BookInfo.new(self,r)}
  end
    
  def book_info(book_id)
    rec = self.book_info_records.find{|r| r["book_id"] == book_id}
    return nil unless rec
    BookInfo.new(self,rec)
  end

  def add_book(book_id)
    @new_books ||= []
    @new_books.push(book_id)
    BookInfo.add(self,book_id)
  end

  def update_book(rec)
    book_info(rec.book_id).update(rec.page_num,rec.updated_at)
  end

  def save_new(condition={},opt={})
    if @new_books
      self.inc("book_num",@new_books.count)
      save_orig(condition.merge!({"book_info_records.book_id" => {"$nin" => @new_books}}),opt)
    else
      save_orig(condition,opt)
    end
  end
  alias save save_new
end
