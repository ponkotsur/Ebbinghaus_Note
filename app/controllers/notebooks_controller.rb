require "classes/EvernoteUtils"

class NotebooksController < ApplicationController
  def index
    @notebooks = Notebook.all
  end

  def show
    @notebook = Notebook.find(params[:id])
    @notes = @notebook.notes
  end

  def update
    @evernote = EvernoteUtils.instance
    @notebooks = @evernote.getNotebooks
    @enable_notes_guid = Array.new
    @notebooks.each do |notebook|
      p notebook
      @new_notebook = Notebook.where(guid: notebook.guid).first
      if !@new_notebook
        @new_notebook = Notebook.new
        @new_notebook.title = notebook.name
        @new_notebook.guid = notebook.guid
        @new_notebook.published = notebook.published
        @new_notebook.save
      end
      p "guid:" + @new_notebook.guid
      @evernote.getNotes(@new_notebook.guid).each do |note|
        @new_note = Note.where(guid: note.guid).first
        @enable_notes_guid.push(note.guid)
        if !@new_note || @new_note.updated != Time.at(note.updated.to_i / 1000).to_date
        # if !@new_note
          if !@new_note
            @new_note = Note.new
          end
          @new_note.notebook_id = @new_notebook.id
          @new_note.title = note.title
          @new_note.content = note.content
          @new_note.guid = note.guid
          @new_note.contentLength = note.contentLength
          @new_note.created = Time.at(note.created.to_i / 1000).to_date
          @new_note.updated = Time.at(note.updated.to_i / 1000).to_date
          @new_note.active = note.active
          @new_note.updateSequenceNum = note.updateSequenceNum
          @new_note.notebookGuid = note.notebookGuid

          if note.resources
            note.resources.each do |resource|
              @url = ""
              case resource.mime
                when "image/gif" then
                  @url = "<image src=\"#{@evernote.getResourceURL(resource.guid)}.gif\"><br>"
                when "image/jpeg" then
                  @url = "<image src=\"#{@evernote.getResourceURL(resource.guid)}.jpg\"><br>"
                when "image/png" then
                  @url = "<image src=\"#{@evernote.getResourceURL(resource.guid)}.png\"><br>"
                # when "application/vnd.evernote.ink" then
                #   @ext = ".ink"
                when "application/pdf" then
                  # @url = "<object data=\"#{@evernote.getResourceURL(resource.guid)}\" type=\"application/pdf\"></object><br>"
                  @url = "<object data=\"#{@evernote.getResourceURL(resource.guid)}\" type=\"application/pdf\" scrolling=\"no\"></object><br>"
                  # @url += "<embed src=\"#{@evernote.getResourceURL(resource.guid)}\" type=\"application/pdf\" width="" height=""></embed><br>"
                  # @url = "<iframe src=\"#{@evernote.getResourceURL(resource.guid)}\" width=\"100%\" height=\"100%\" ></iframe>"
                  # @url = "<iframe src=\"#{@evernote.getResourceURL(resource.guid)}.pdf\" style=\"border:0\" width=\"100%\" height=\"100%\" frameborder=\"0\" scrolling=\"no\"></iframe>"
                  # @url = "<iframe src=\"file=#{@evernote.getResourceURL(resource.guid)}.pdf\" style=\"border:0\" width=\"100%\" height=\"100%\" frameborder=\"0\" scrolling=\"no\"></iframe>"
              end
              p resource.mime
              @new_note.content += @url
            end
          end

          # @html = Nokogiri::HTML(@new_note.content)
          # @enmedia_nodes = @html.xpath('//')
          # @enmedia_nodes.each do |en_media|
          #   p "en-media:" + en_media.text
          # end
          @new_note.save
        end    
      end
    end

    @delete_sql = "not guid in("
    @notebooks.each do |notebook|
      @delete_sql = @delete_sql + "\"" + notebook.guid.to_s + "\","
    end
    @delete_sql = @delete_sql[0..-2] + ")"
    p @delete_sql
    Notebook.where(@delete_sql).destroy_all    

    if @enable_notes_guid.length > 0
      @delete_sql = "not guid in("
      @enable_notes_guid.each do |enable_note_guid|
        @delete_sql = @delete_sql + "\"" + enable_note_guid + "\","
      end
      @delete_sql = @delete_sql[0..-2] + ")"
      p @delete_sql
      Note.where(@delete_sql).destroy_all
    end

    redirect_to :action => "index"
  end
end
