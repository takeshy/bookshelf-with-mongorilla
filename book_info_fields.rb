#coding: utf-8
module BookInfoFields
  Fields = [:book_id,:page_num,:created_at,:updated_at]

  Fields.each do |f|
    define_method(f) { @info[f.to_s] }
  end

  def renewal(new_info)
    Fields.each do |f|
      @info[f.to_s] = new_info.send(f)
    end
  end
end
