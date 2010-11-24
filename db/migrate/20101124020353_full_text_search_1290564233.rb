class FullTextSearch1290564233 < ActiveRecord::Migration
  def self.up
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS messages_fts_idx
    eosql
    execute(<<-'eosql'.strip)
      CREATE index messages_fts_idx
      ON messages
      USING gin((to_tsvector('english', coalesce("messages"."subject", '') || ' ' || coalesce("messages"."body", ''))))
    eosql
  end

  def self.down
    execute(<<-'eosql'.strip)
      DROP index IF EXISTS messages_fts_idx
    eosql
  end
end
