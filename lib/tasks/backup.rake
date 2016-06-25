namespace :backup do
  desc 'Backup application DB'
  task run: :environment do
    puts 'Creating DB dump'
    `pg_dump -Fc --no-acl --no-owner $BACKUP_DB_NAME -p $DB_PORT > #{Rails.root.join('backup/database.dump')}`

    puts 'Uploading to FTP'
    ENV['PASSPHRASE'] = ENV['BACKUP_PASSPHRASE']
    `duplicity #{Rails.root.join('backup')} #{ENV['BACKUP_FTP_URL']}#{ENV['BACKUP_FTP_DIR']} --allow-source-mismatch --full-if-older-than=7D`

    EventTracker.track :backup, :create, :database
  end
end
