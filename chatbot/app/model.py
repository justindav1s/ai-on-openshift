class Exchange:

    def __init__(self, who, sentence):
        self.who = who
        self.sentence = sentence

    def toString(self):
        print
        "who : ", self.who, ", sentence: ", self.sentence