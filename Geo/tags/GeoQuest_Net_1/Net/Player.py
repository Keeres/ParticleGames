from time import time
from GameStates import GameStates
from Database import AllPlayers, QueuedPlayers, ChallengesInProgress
from PacketHandler import PacketHandler

class Player(object):
    def __init__(self, protocol, db_session, uuid):
        self.protocol = protocol
        self.db_session = db_session
        self.info = None
        self.match = None
        self.check_player_exists(uuid)

        self.handler = PacketHandler()

        self.protocol.sendPacket(self.handler.create(GameStates.PLAYER_HISTORY, 'PlayerConnected:Success'))

        print '{0}: Player Connected: {1} '.format(int(self.info.last_login), self.info.uuid)

        # Done with player initialization. Store player info
        self.db_session.add(self.info)
        self.db_session.commit()


    def check_player_exists(self, uuid):
        # querying for a record in the Artist table
        self.info = self.db_session.query(AllPlayers).filter(AllPlayers.uuid == uuid).first()
        if (self.info):
            self.info.last_login = int(time())
            self.info.login_count = self.info.login_count + 1
        else:
            self.store_new_player(uuid)


    def store_new_player(self, uuid):
        self.info = AllPlayers(uuid = uuid,
                               last_login = int(time()),
                               login_count = 0,
                               name = 'Test User',
                               email = 'abc@xyz.com',
                               picture = 'noob.png')

    def add_to_queue(self):
        new_queue = QueuedPlayers(player_id     = self.info.id,
                                  time_in_queue = int(time()))
        self.db_session.add(new_queue)
        self.db_session.commit()

    def create_challenge(self, challenger):
        new_challenge = ChallengesInProgress(match_start_time   = int(time()),
                                             player_last_played = int(time()),
                                             player_id          = self.info.id,
                                             player_wins        = 0,
                                             challenger_id      = challenger.id,
                                             challenger_wins    = 0,
                                             turn               = 'PLAYER')
        self.db_session.add(new_challenge)
        self.db_session.commit()

    def process_state(self, state, data):
        if (state == GameStates.PLAYER_HISTORY):
            self.protocol.sendPacket(self.protocol.gameState.player_history('LastLogin:{0};LoginCount{1}'.format(self.info.last_login, self.info.login_count)))

        elif (state == GameStates.REQUEST_PLAYER_INFO):
            self.protocol.sendPacket(self.protocol.gameState.request_player_info('Player:{0}'.format(self)))

        elif (state == GameStates.REQUEST_PLAYER_INFO):
            self.protocol.sendPacket(self.protocol.gameState.request_player_info('Player:{0}'.format(self)))

        elif (state == GameStates.MATCH_INIT):
            if (len(data) == 36):
                challenger = self.db_session.query(AllPlayers).filter(AllPlayers.uuid == data).first()
                if (challenger):
                    self.create_challenge(challenger)
                    self.protocol.sendPacket(self.handler.create(GameStates.MATCH_INIT, 'Found challenger'))
                else:
                    self.add_to_queue()
                    self.protocol.sendPacket(self.handler.create(GameStates.MATCH_INIT, 'Added to queue'))

            else:
                self.add_to_queue()
                self.protocol.sendPacket(self.handler.create(GameStates.MATCH_INIT, 'Added to queue'))


    def __repr__(self):
        return "%s:%s" % (self.info.uuid)

