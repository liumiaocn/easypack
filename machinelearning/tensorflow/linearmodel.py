import tensorflow as tf
import numpy      as np
import os
import matplotlib.pyplot as plt
from   sklearn import datasets
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

class LinearModel:
  irisdata =  datasets.load_iris()
  xdata = irisdata.data[:,2]
  ydata = irisdata.data[:,3]
  X = tf.placeholder("float",name="X")
  Y = tf.placeholder("float",name="Y")
  W = tf.Variable(-3., name="W")
  B = tf.Variable(3., name="B")
  linearmodel = tf.add(tf.multiply(X,W),B)
  lossfunc = (tf.pow(Y - linearmodel, 2))
  learningrate  = 0.01
  learningsteps = 100

  def load(self, xindex, yindex):
    self.irisdata =  datasets.load_iris()
    self.xdata    =  self.irisdata.data[:,xindex]
    self.ydata    =  self.irisdata.data[:,yindex]

  def train(self):
    trainoperation = tf.train.GradientDescentOptimizer(self.learningrate).minimize(self.lossfunc)
    sess = tf.Session()
    init = tf.global_variables_initializer()
    sess.run(init)

    index = 1
    print("caculation begins ...")
    for i in range(self.learningsteps):
      for (x,y)  in zip(self.xdata,self.ydata):
        sess.run(trainoperation, feed_dict={self.X: x, self.Y:y})
    print("caculation ends ...")
    return self.B.eval(session=sess),self.W.eval(session=sess)
