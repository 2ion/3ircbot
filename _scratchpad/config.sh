#
# 3ircbot
#

SERVER=camelia.2ion.de
PORT=6669
CHANNELS=(botpit botpit2)
NICKNAME=Vercingetorix
REALNAME=Vercingetorix
PREFIX=.

# from-channel, from-nick, message

_date () {
  echo "$(date)"
}

register .date  _date
register .      _relay
