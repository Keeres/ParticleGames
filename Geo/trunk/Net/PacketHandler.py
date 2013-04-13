from Packet import Packet

HEADER_SIZE = 16
KEYWORD_SIZE = 8
TOTAL_HEADER_SIZE = KEYWORD_SIZE + HEADER_SIZE
PACKET_KEYWORD = 'PARTICLE'


class PacketHandler(object):

    def __init__(self):
        self.packet = None

    def findNext(self, data):
        # Check if there is enough data to process
        if (len(data) >= TOTAL_HEADER_SIZE):
            packetStart = data.find(PACKET_KEYWORD)

            if (packetStart > -1):
                packetStart += KEYWORD_SIZE

        return packetStart


    def extract(self, data):
        self.packet = Packet(data[: HEADER_SIZE])

        # Check if we received enough data.
        if (len(data[HEADER_SIZE :]) >= self.packet.DataSize):
            self.packet.setData(data[HEADER_SIZE: HEADER_SIZE + self.packet.DataSize])
            return HEADER_SIZE + self.packet.DataSize;

        else:
            return -1


    def getPackedData(self):
        return self.packet.pack()
    
    
    def getPackedDataFromPacket(self, packet):
        return packet.pack()
    

    def get(self):
        return self.packet;


    def create(self, gameState, data):
        self.packet = Packet('')
        self.packet.generate(gameState, data)
        return self.packet
    
    def DEBUG_PRINT_PACKET(self):
        self.packet.DEBUG_DUMP()