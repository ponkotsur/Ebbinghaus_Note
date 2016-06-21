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
        if !@new_note || @new_note.updated != Time.at(note.updated.to_i / 1000).to_date
        # if !@new_note
          @new_note = Note.new
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
              @ext = ""
              case resource.mime
                when "image/gif" then
                  @ext = ".gif"
                when "image/jpeg" then
                  @ext = ".jpg"
                when "image/png" then
                  @ext = ".png"
                when "application/vnd.evernote.ink" then
                  @ext = ".ink"
              end
              p resource.mime
              @url = "<image src=\"#{@evernote.getResourceURL(resource.guid) + @ext}\"><br>"
              @new_note.content += @url
            end
          end

          xml = Nokogiri::XML(@new_note.content)
          enmedia_nodes = xml.xpath('//en-media')
          enmedia_nodes.each do |en_media|
            p en_media
          end
          @new_note.save
        end    
      end
    end
    redirect_to :action => "index"
  end
end
