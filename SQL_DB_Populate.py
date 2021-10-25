import random

from sqlalchemy import create_engine, ForeignKey
from sqlalchemy import Column, Date, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship, sessionmaker
from data_generation import DataGenerator

DATABASE_URI = 'mysql+pymysql://h@127.0.0.1/Research_Study'
engine = create_engine(DATABASE_URI, echo=True)
Base = declarative_base()

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    name = Column(String(100), index=True, nullable=False, unique=False)
    password = Column(String(100), unique=False)


class Participant(Base):
    __tablename__ = "study_participants"

    id = Column(Integer, primary_key=True)
    name = Column(String(100), index=True, nullable=False, unique=False)

    # Personal information:
    dob = Column(String(100), unique=False)
    weight = Column(Integer, unique=False)
    race = Column(String(100), unique=False)
    income = Column(Integer, unique=False)


class Staff(Base):
    __tablename__ = "staff"

    id = Column(Integer, primary_key=True)
    name = Column(String(100), index=True, nullable=False, unique=False)
    dob = Column(String(100), unique=False)
    role = Column(String(20), unique=False)


class Contact(Base):
    __tablename__ = "contact_for_participants"

    id = Column(Integer, primary_key=True)
    email = Column(String(100), unique=False)
    phone = Column(String(100), unique=False)
    address = Column(String(100), unique=False)

    user_id = Column(Integer, unique=False)

Base.metadata.create_all(engine)

#Now, use data.generation.py to populate the SQL Database with fake data
gen = DataGenerator()

session = sessionmaker(bind=engine)
session = session()


N = 73

#Genrate fake data
names = gen.name(N)
passwrds = gen.password(N)
dobs = gen.date(N)
weights = gen.weight(N)
races = gen.race(N)
incomes = gen.weight(N)
names2 = gen.name(N)
dobs2 = gen.date(N)
emails = gen.date(N)
phones = gen.phone(N)
addresses = gen.address(N)

users = []
participants = []
staff = []
contacts = []
for i in range(N):
    newUser = User(name=names[i], password=passwrds[i])
    users.append(newUser)

    newParticipant = Participant(name=names[i], dob=dobs[i], weight=weights[i], race=races[i], income=incomes[i])
    participants.append(newParticipant)

for i in range(58):
    newStaff = Staff(name=names2[i], dob=dobs[i], role=random.choice(["TA", "Professor"]))
    staff.append(newStaff)

    newContact = Contact(email=emails[i], phone=phones[i], address=addresses[i], user_id=i)
    contacts.append(newContact)

all_data = [users, participants, staff, contacts]
for data in all_data:
    session.add_all(data)

session.commit()

#generate some fake files
doc_names = ["research_proposal", "study_confirmation", "permission_form"]
for n in doc_names:
    gen.document(n)



