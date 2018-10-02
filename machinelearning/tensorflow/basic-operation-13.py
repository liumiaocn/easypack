import tensorflow as tf
import numpy      as np
import os
import matplotlib.pyplot as plt

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

xdata = np.linspace(0,1,100)
ydata = 2 * xdata + 1 + np.random.normal(20,6,xdata.shape)*0.02

print("init modole ...")
X = tf.placeholder("float",name="X")
Y = tf.placeholder("float",name="Y")
W = tf.Variable(-3., name="W")
B = tf.Variable(3., name="B")
linearmodel = tf.add(tf.multiply(X,W),B)
lossfunc = (tf.pow(Y - linearmodel, 2))
learningrate = 0.01

print("set Optimizer")
trainoperation = tf.train.GradientDescentOptimizer(learningrate).minimize(lossfunc)

sess = tf.Session()
init = tf.global_variables_initializer()
sess.run(init)

index = 1
print("caculation begins ...")
for j in range(100):
  for i in range(100):
    sess.run(trainoperation, feed_dict={X: xdata[i], Y:ydata[i]})
  if j % 10 == 0:
    print("j = %s index = %s" %(j,index))
    plt.subplot(2,5,index) 
    plt.scatter(xdata,ydata)
    labelinfo="iteration: " + str(j)
    plt.plot(xdata,B.eval(session=sess)+W.eval(session=sess)*xdata,'b',label=labelinfo)
    plt.plot(xdata,2*xdata + 1,'r',label='expected')
    baisadjust=np.mean(ydata) - np.mean(B.eval(session=sess)+W.eval(session=sess)*xdata)
    plt.plot(xdata,2*xdata + 1 + baisadjust, 'y', label='adjusted')
    plt.legend() 
    index = index + 1

print("caculation ends ...")
print("##After Caculation: ") 
print("   B: " + str(B.eval(session=sess)) + ", W : " + str(W.eval(session=sess)))

plt.show()
