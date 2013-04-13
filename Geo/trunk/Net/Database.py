
from sqlalchemy import create_engine, ForeignKey
from sqlalchemy import Column, Date, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, backref

engine = create_engine('sqlite:///server_test.sqlite', echo=True)
Base = declarative_base()

class AllPlayers(Base):
    __tablename__ = "AllPlayers"

    id            = Column(Integer, primary_key = True)
    uuid          = Column(String, nullable = False, unique = True)
    last_login    = Column(Integer)
    login_count   = Column(Integer)
    name          = Column(String)
    email         = Column(String)
    password      = Column(String)
    picture       = Column(String)

class QueuedPlayers(Base):
    __tablename__ = "QueuedPlayers"

    id            = Column(Integer, primary_key = True)
    player_id     = Column(Integer, ForeignKey("AllPlayers.id"))
    time_in_queue = Column(Integer)

class ChallengesInProgress(Base):
    __tablename__ = "ChallengesInProgress"

    id                     = Column(Integer, primary_key = True)
    match_start_time       = Column(Integer)
    player_id              = Column(Integer, ForeignKey("AllPlayers.id"))
    player_wins            = Column(Integer)
    player_last_played     = Column(Integer)
    player_prev_race       = Column(String)
    player_next_race       = Column(String)
    challenger_id          = Column(Integer, ForeignKey("AllPlayers.id"))
    challenger_wins        = Column(Integer)
    challenger_last_played = Column(Integer)
    challenger_prev_race   = Column(String)
    challenger_next_race   = Column(String)
    turn                   = Column(String)
    question               = Column(String)


# create tables
Base.metadata.create_all(engine)
