require 'ramaze'
require 'm4dbi'

$dbh = DBI.connect( 'DBI:Pg:reby-memo', 'memo', '' )

class Memo < DBI::Model( :memos )
end

class Main < Ramaze::Controller
  def index( recipient = nil )
    if recipient
      @recipient = recipient
      @memos = Memo.s(
        %{
          SELECT *
          FROM memos m
          WHERE
            m.recipient = ?
            OR ? ~ m.recipient_regexp
          ORDER BY
            time_sent DESC
        },
        recipient,
        recipient
      )
    end
  end
end

Ramaze.start( adapter: :thin, port: 8027 )