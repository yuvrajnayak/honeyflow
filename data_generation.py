"""
Script with various methods to generate
the fake honey.

Will not run directly - other scripts need to call
this file to add things to a database/files
"""
from faker import Faker
import random, os, string


class DataGenerator:
    """
    Call these public methods to get an array of
    fake data:

    name
    address
    password
    date
    weight
    income
    race
    phone
    document -> create new file with passed name in the current dir

    """
    def __init__(self):
        self.fake = Faker()
        self.zip_codes = ["21034", "21075", "20737", "20740", "20742"]
        self.area_codes = ["410", "667"]
        self.ethnicities = ["White", "Black", "American Indian", "Chinese", "Korean", "Japenese", "Indian", "Pakistani", "Asian", "Middle East"]

    def generate_array(self, generate_method, n: int):
        arr = []
        for _ in range(n):
            arr.append(generate_method())
        return arr

    def name(self, n: int):
        return self.generate_array(self.fake.name, n)

    def _get_next_add(self):
        zip_codes = ["21034", "21075", "20737", "20740", "20742"]
        return self.fake.address().split(",")[0] + " MD " + random.choice(zip_codes)

    def address(self, n: int):
        return self.generate_array(self._get_next_add, n)

    def _get_next_passwd(self):
        # printing lowercase
        letters = string.ascii_lowercase
        ret = ''.join(random.choice(letters) for i in range(10))

        # printing digits
        letters = string.digits
        ret += ''.join(random.choice(letters) for i in range(10))

        return ret

    def password(self, n: int):
        return self.generate_array(self._get_next_passwd, n)

    def date(self, n: int):
        return self.generate_array(self.fake.date, n)

    def _weight(self):
        return random.randint(90, 300)

    def weight(self, n: int):
        return self.generate_array(self._weight, n)

    def _income(self):
        return random.randint(20000, 500000)

    def income(self, n: int):
        return self.generate_array(self._income, n)

    def _phone(self):
        return str(random.choice(self.area_codes) + "-" + str(random.randint(111, 999)) + "-" + str(random.randint(1111, 9999)))

    def phone(self, n: int):
        return self.generate_array(self._phone, n)

    def _race(self):
        return random.choice(self.ethnicities)

    def race(self, n: int):
        return self.generate_array(self._race, n)

    def document(self, name: str):
        with open(name + ".docx", 'wb') as fout:
            fout.write(os.urandom(30024))

test = DataGenerator()
print(test.name(100))

test.document("hello.docx")



