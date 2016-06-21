# -*- coding: utf-8 -*-
require "evernote_oauth"
require "active_support"
require "singleton"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class EvernoteUtils
  #シングルトンを利用
  include Singleton

  #初期化　トークン取得
  def initialize
    puts("NoteStore取得")
    @token = "S=s1:U=9290b:E=15cc2c3677a:C=1556b1237e0:P=1cd:A=en-devtoken:V=2:H=986913b9d89b57beb8eac5d2c59eb4b3"
    @username = "ponkotsur"
    @client = EvernoteOAuth::Client.new(:token => @token, :sandbox => true)
    @note_store = @client.note_store
    @user_store = @client.user_store
  end

  #ノートブック一覧取得
  def getNotebooks
    return @note_store.listNotebooks
  end

  #名前からノートブック取得
  def searchNotebook(notebook_name)
    puts("ノートブック取得")
    @notebooks = @note_store.listNotebooks.select do |notebook|
      notebook.name == notebook_name
    end
    return @notebooks.first.guid
  end

  #GUIDからノートを取得
  def searchNoteWithGuid(guid)
    return @note_store.getNote(@token,guid,true,true,true,true)
  end

  def getResourceURL(guid)
    @user_info = @user_store.getPublicUserInfo(@username)
    @res_guid = guid
    return "#{@user_info.webApiUrlPrefix}res/#{@res_guid}"
  end

  def createNote(note)
    # puts("ノート作成：")

    # ENML_HEADER = <<HEADER
    # <?xml version="1.0" encoding="UTF-8"?>
    # <!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
    # HEADER

    # note_content = <<CONTENT
    # #{ENML_HEADER}
    # <en-note>Hello, my Evernote (from Ruby)!</en-note>
    # CONTENT

    # note = Evernote::EDAM::Type::Note.new
    # note.title        = "ノートのタイトル"
    # note.notebookGuid = notebook_guid
    # note.content      = note_content

    # note_store.createNote(token, note)
    # puts("ここでスクショ取る")
    # gets
  end

  #パラメータから街頭のノートのみを取得
  def getEbbinghaus(notebook_guid,conditions)
    puts("ノート検索：")
    @filter = Evernote::EDAM::NoteStore::NoteFilter.new
    @filter.notebookGuid = notebook_guid
    @spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
    @spec.includeCreated = true

    @extractedNotes = Array.new

    @metadatas = @note_store.findNotesMetadata(@token, @filter, 0, 10,@spec)
    @metadatas.notes.each do |note|
      p "guid:" + note.guid.to_s
      p "created:" + Time.at(note.created.to_i / 1000).to_s
      @createdDate = Time.at(note.created.to_i / 1000).to_date
      conditions.each do |condition|
        @condition_date = Date.today - condition
        if @createdDate  == @condition_date
            @extractedNotes.push(searchNoteWithGuid(note.guid))  
          break
        end
      end
    end
    return @extractedNotes
  end

  #GUIDからノート一覧を取得
  def getNotes(notebook_guid)
    @filter = Evernote::EDAM::NoteStore::NoteFilter.new
    @filter.notebookGuid = notebook_guid
    @spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
    @spec.includeCreated = true

    @extractedNotes = Array.new

    @metadatas = @note_store.findNotesMetadata(@token, @filter, 0, 10,@spec)
    @metadatas.notes.each do |note|
      @extractedNotes.push(searchNoteWithGuid(note.guid))
    end
    return @extractedNotes
  end

  # new_note = Evernote::EDAM::Type::Note.new
  # new_note.title   = "#{found_note.title}を変えてみました"
  # new_note.guid    = found_note.guid
  # new_note.content = <<CONTENT
  # #{ENML_HEADER}
  # <en-note>
  # <h1>Hello Evernote!</h1>
  # <div>test</div>
  # </en-note>
  # CONTENT

  # note_store.updateNote(token, new_note)
  # puts("ここでスクショとったら完了")

end

# token = "S=s1:U=9290b:E=15c677701ea:C=1550fc5d3d8:P=1cd:A=en-devtoken:V=2:H=3665f3cf53c01de231919a1743759f1d"
# utils = EvernoteUtils.new(token)

# conditions = [0,30,90,120,150]
# notebook = utils.searchNotebook("Qiita notebook")
# notes = utils.getEbbinghaus(notebook,conditions)
# p notes.length