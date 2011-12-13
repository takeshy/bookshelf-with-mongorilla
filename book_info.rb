#coding: utf-8
require File.expand_path("./book_info_fields", File.dirname(__FILE__))
require File.expand_path("./bookshelf", File.dirname(__FILE__))
class BookInfo
  include BookInfoFields

  def update(page_num,updated_at)
    idx = @bookshelf.book_info_records.index{|r| r["book_id"] == @info["book_id"] }
    @bookshelf.changes["$set"] ||={}
    @bookshelf.changes["$set"]["book_info_records.#{idx}.page_num"] = page_num
    @bookshelf.changes["$set"]["book_info_records.#{idx}.updated_at"] = updated_at
    @info["page_num"] = page_num
    @info["updated_at"] = updated_at
  end

  def self.add(bookshelf,book_id)
    bookshelf.changes["$pushAll"] ||= {}
    bookshelf.changes["$pushAll"]["book_info_records"] ||= []
    if bookshelf.origin["book_info_records"].find{|r| r["book_id"] == book_id}
      raise "already exists!!"
    end
    if bookshelf.changes["$pushAll"]["book_info_records"].find{|r| r["book_id"] == book_id}
      raise "already push!!"
    end
    now = Time.now
    record = {"book_id" => book_id,"page_num" => 0,"created_at" => now,"updated_at" => now}
    bookshelf.changes["$pushAll"]["book_info_records"].push(record)
    bookshelf.book_info_records.push(record)
  end

  def initialize(bookshelf,rec)
    @bookshelf = bookshelf
    @info = rec
  end
end
