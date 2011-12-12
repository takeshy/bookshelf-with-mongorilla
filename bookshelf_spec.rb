#coding: utf-8
require 'rspec'
require 'logger'
require File.expand_path("./user", File.dirname(__FILE__))

describe  Bookshelf do
  before do
    Mongorilla::Collection.build(File.expand_path("./mongo.yml", File.dirname(__FILE__)))
    @user = User.build(:name => "morita")
  end

  context "bookshelf" do
    it{@user.bookshelf.should_not be_nil}
  end

  describe "本を追加(正常)" do
    before do
      @user.bookshelf.add_book("1")
      @user.bookshelf.add_book("2")
      @user.bookshelf.save
      @bookshelf = Bookshelf.find(@user.bookshelf.id)
    end
    it{ @bookshelf.book_infos.map(&:book_id) =~ ["1","2"]}
    it{ @bookshelf.book_num.should == 2}
  end

  describe "本を追加(異常)" do
    before do
      @user.bookshelf.add_book("1")
      @bookshelf = Bookshelf.find(@user.bookshelf.id)
      @bookshelf.add_book("1")
      @user.bookshelf.save
      @ret = @bookshelf.save
      @bookshelf.reload
    end
    it{ @ret.should == false}
    it{ @bookshelf.book_infos.map(&:book_id) =~ ["1"]}
    it{ @bookshelf.book_num.should == 1}
  end

  describe "読書結果を反映" do
    before do
      @user.bookshelf.add_book("1")
      @user.bookshelf.add_book("2")
      #本の追加を更新
      @user.bookshelf.save
      @user.current_book_info.change(@user.bookshelf.book_infos[0])
      #手元の本をBookID1の本にする
      @user.save
      #本を10ページ読みすすめる
      @user.current_book_info.inc(10)
      @user.save
      @user.reload
    end
    it{@user.current_book_info.page_num.should == 10}
    it{@user.current_reading_logs.count.should == 1}
    describe "本を変更" do
      before do
        @user.bookshelf.update_book(@user.current_book_info)
        #本棚の本の情報を手元の本の情報で更新
        @user.bookshelf.save
        @user.current_book_info.change(@user.bookshelf.book_infos[1])
        #手元の本をBookID2の本にする
        @user.save
        @user.reload
      end
      it{@user.current_book_info.page_num.should == 0}
    end
  end
  after do
    User.remove()
    Bookshelf.remove()
  end
end
