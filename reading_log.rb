#coding: utf-8
require 'mongorilla'
class ReadingLog
  ReadingLogFields = [:_id,:book_id,:user_id,:page_num,:created_at]
  include Mongorilla::Document
end
