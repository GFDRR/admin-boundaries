import sys
import codecs
import unicodedata
import random

with codecs.open(sys.argv[1], encoding="UTF-8") as raw_data:
    data = raw_data.readlines()

    random.shuffle(data)

    test_data = data[:len(data)/2]
    validation_data = data[len(data)/2:]

    with open('test-capitals.txt', 'w') as test_file:
        test_file.writelines("".join(test_data).encode('utf8'))

    with open('validation-capitals.txt', 'w') as validation_file:
        validation_file.writelines("".join(validation_data).encode('utf8'))
