from PacketHandler import PacketHandler
from Packet import Packet

class GameStates(object):

    PLAYER_INIT = 1
    PLAYER_CONNECTED = 2
    PLAYER_DISCONNECT = 3
    PLAYER_TIMEOUT = 4
    PLAYER_HISTORY = 5
    PLAYER_SERVER_SETTINGS = 6
    PLAYER_DATA_UPLOAD = 7
    PLAYER_DATA_DOWNLOAD = 8
    PLAYER_DATA_DELETE = 40


    MATCH_INIT = 50
    MATCH_SYNC = 51
    MATCH_SEARCHING = 52
    MATCH_NOTIFY = 53
    MATCH_WAITING = 54
    MATCH_TIMEOUT = 55
    MATCH_READY = 60
    MATCH_STARTED = 61
    MATCH_FORCE_QUIT = 62
    MATCH_END = 63
    MATCH_RESTART = 64
    MATCH_STATE_PLAYER = 65
    MATCH_STATE_OPPONENT = 66
    MATCH_RESULTS = 67
    MATCH_FORCE_PEER = 110
    MATCH_FORCE_RESET = 111


    GAME_GENERATION_INIT = 120
    GAME_DOWNLOAD_INIT = 121
    GAME_QUESTION = 122
    GAME_VERIFY = 123
    GAME_TRANSFER_COMPLETE = 124
    GAME_TRANSFER_RESET = 125
    GAME_INFO = 126
    GAME_DELETE = 127
    GAME_HISTORY = 128
    GAME_RESET = 129
    GAME_DUMP = 190


    REQUEST_MATCH_INFO = 200
    REQUEST_PLAYER_SAVE_DATA = 201
    REQUEST_PLAYER_INFO= 202
    REQUEST_SESSION_INFO = 203
    REQUEST_SERVER_STATS =204
    REQUEST_SERVER_GAME_POOL = 205
    REQUEST_SERVER_INFO = 206
    REQUEST_SERVER_TERRITORIES = 207
    REQUEST_SERVER_DUMP= 255

    def __init__(self):
        self.handler = PacketHandler()


    def player_init(self, data):
        return self.handler.create(self.PLAYER_INIT, data)


    def player_connected(self, data):
        return self.handler.create(self.PLAYER_CONNECTED, data)


    def player_disconnected(self):
        return self.handler.create(self.PLAYER_DISCONNECT, '')


    def player_history(self, data):
        return self.handler.create(self.PLAYER_HISTORY, data)


    def request_player_info(self, data):
        return self.handler.create(self.REQUEST_PLAYER_INFO, data)

