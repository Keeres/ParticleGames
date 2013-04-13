from struct import pack, unpack
from time import time
from zlib import crc32


# Generic Packet Definition
# 64 bit keyword string
# 32 bit packet CRC (created by all enclosed data plus 64 bit secret unique passphrase)
# 64 bit tzinfo timestamp (used by server for sanity check and prevent race conditions)
# 8 bit game state (0 to 255)
# 8 bit packet counter (0 to 255)
# 16 bit data size (0 to 65535)
# Data (max data 65535 bytes, or 64 kilobytes)


HEADER_SIZE = 16
PACKET_KEYWORD = 'PARTICLE'
RECEIVE_HEADER_DEFINITION = '! l Q B B H'
DATA_FOR_CRC_DEFINITION   = '! Q B B H %ss'
FULL_PACKED_DEFINITION    = '! 8s l Q B B H %ss'


class Packet(object):

    CRC             = 0
    TimeStamp       = 0
    GameState       = 0
    PacketCounter   = 0
    DataSize        = 0
    Data            = 0

    Valid           = False
    Type            = 0
    
    NextPacket      = None


    def __init__(self, header):
        self.PacketType = self.enum('RECEIVE', 'SENT')
        
        if (len(header) == HEADER_SIZE):
            self.CRC, self.Timestamp, self.GameState, self.PacketCounter, self.DataSize = unpack(RECEIVE_HEADER_DEFINITION, header)
            self.Type = self.PacketType.RECEIVE;
            
            
    def generate(self, state, data):
        self.Timestamp = time()
        
        self.GameState = state
        self.Data = data
        self.DataSize = len(data)        
        self.CRC = self.getCRC()
        
        self.Type = self.PacketType.SENT
        self.Valid = True
        
        
    def setData(self, data):
        self.Data = data
        self.verifyCRC()
        
    
    def verifyDataSize(self):
        if (self.DataSize != self.Data):
            self.Valid = False
        else:
            self.Valid = True


    def verifyCRC(self):
        newCRC = self.getCRC()
        if (self.CRC != newCRC):
            self.Valid = False
        else:
            self.Valid = True


    def verify(self):
        if (self.DataSize != self.Data):
            self.DataSize = len(self.Data)
        
        newCRC = self.getCRC()
        if (self.CRC != newCRC):
            self.CRC = newCRC
            
        return true


    def getCRC(self):
        return crc32(pack(DATA_FOR_CRC_DEFINITION % str(self.DataSize), self.Timestamp, self.GameState, self.PacketCounter, self.DataSize, self.Data))

    
    def pack(self):
        return pack(FULL_PACKED_DEFINITION % str(self.DataSize), PACKET_KEYWORD, self.CRC, self.Timestamp, self.GameState, self.PacketCounter, self.DataSize, self.Data)


    def enum(*sequential, **named):
        enums = dict(zip(sequential, range(len(sequential))), **named)
        reverse = dict((value, key) for key, value in enums.iteritems())
        enums['reverseMapping'] = reverse
        return type('Enum', (), enums)


    def DEBUG_DUMP(self):
        print 'Packet Dump'
        print 'Valid          :: ' + str(self.Valid)
        print 'Type           :: ' + self.PacketType.reverseMapping[self.Type]
        print 'CRC            :: ' + hex(self.CRC)
        print 'Timestamp      :: ' + str(self.Timestamp)
        print 'Game State     :: ' + str(self.GameState)
        print 'Packet Counter :: ' + str(self.PacketCounter)
        print 'Data Size      :: ' + str(self.DataSize)
        print 'Data           ::  `' + self.Data + '`'
        
