import random

from pymongo import MongoClient
from data_generation import DataGenerator

conn = MongoClient('mongodb://localhost:27017/')

db = conn['database']

users_db = db["users"]
participants_db = db["participants"]
staff_db = db["staff"]
contacts_db = db["contacts"]

N = 1000

#Genrate fake data
gen = DataGenerator()
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
    newUser = {"id": i, "name": names[i], "password": passwrds[i]}
    users_db.insert_one(newUser)
    users.append(newUser)

    newParticipant = {"id":i, "name":names[i], "dob":dobs[i], "weight":weights[i], "race":races[i], "income":incomes[i]}
    participants_db.insert_one(newParticipant)
    participants.append(newParticipant)

    newStaff = {"id":i, "name":names2[i], "dob":dobs[i], "role": random.choice(["TA", "Professor"])}
    staff_db.insert_one(newStaff)
    staff.append(newStaff)

    newContact = {"id":i, "email":emails[i], "phone":phones[i], "address":addresses[i], "user_id":i}
    contacts_db.insert_one(newContact)
    contacts.append(newContact)

#users_db.insert_many(users)
#participants_db.insert_many(participants)
#staff_db.insert_many(staff)
#contacts_db.insert_many(contacts)

#generate some fake files
doc_names = ["research_proposal", "study_confirmation", "permission_form"]
for n in doc_names:
    gen.document(n)
