class Image:

    def __init__(self, url, classification, prob):
        self.classification = classification
        self.url = url
        self.prob = prob

    def toString(self):
        print ("url : "+self.url+" category : "+self.classification+" prob : "+self.prob)
