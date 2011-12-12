#coding: utf-8
require File.expand_path("./book_info_fields", File.dirname(__FILE__))
class CurrentBookInfo
  include BookInfoFields

  def book
    return nil if !@info || @info["book_id"]
    BookMaster.find(@info["book_id"])
  end

  def change(new_info)
    @user.changes["$set"] ||= {}
    renewal(new_info)
    @user.changes["$set"]["current_book_info_rec"] = @info
  end
    
  def inc(num)
    now = Time.now
    ReadingLog.create(:book_id=>self.book_id,:user_id=>@user.id,:page_num => num,:created_at => now)
    @user.changes["$inc"] ||= {}
    @user.changes["$inc"]["current_book_info_rec.page_num"] = num
    @user.changes["$set"] ||= {}
    @user.changes["$set"]["current_book_info_rec.updated_at"] = now
    @info["page_num"] += num
    @info["jupdated_at"] = now
  end

  def initialize(user,rec)
    @user = user
    @info = rec
  end
end
