# frozen_string_literal: true

require 'zip'

class Files::Set
  def call(winners)
    files = []

    winners.each_with_index do |winner, index|
      files << create_pdf(winner, index)
    end
    blobs = save_to_db(files)
    archive = create_archive_for(files)

    [blobs, archive]
  end

  private

  def create_pdf(winner, index)
    kit = PDFKit.new(<<-HTML)
      <p>Congratulations <b>#{winner}</b></p>
      <p>You took #{index+1} place </p>
    HTML

    kit.to_file("#{Rails.root}/public/pdfs/winner#{index+1}.pdf")
  end

  def save_to_db(files)
    blobs = []

    files.each do |f|
      blobs << create_blob(f, 'application/pdf')
    end
    blobs
  end

  def create_archive_for(files)
    name = (0...50).map { ('a'..'z').to_a[rand(26)] }.join

    archive_path = "#{Rails.root}/public/archives/#{name}.zip"

    archive = Zip::File.open(archive_path, Zip::File::CREATE) do |zipfile|
      files.each do |file|
        zipfile.add(file.path.split('/').last, file.path)
      end
    end

    create_blob(File.open(archive_path), 'application/zip')
  end

  def create_blob(file, type)
    ActiveStorage::Blob.create_after_upload!(
      io: file, filename: file.path.split('/').last, content_type: type
    )
  end
end
