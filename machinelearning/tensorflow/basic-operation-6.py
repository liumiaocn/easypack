import tensorflow as tf
import numpy      as np
import os
import matplotlib.pyplot as plt

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

xdata = np.linspace(0,1,100)
ydata = 2 * xdata + 1

print("init modole ...")
X = tf.placeholder("float",name="X")
Y = tf.placeholder("float",name="Y")
W = tf.Variable(3., name="W")
B = tf.Variable(3., name="B")
linearmodel = tf.add(tf.multiply(X,W),B)
lossfunc = (tf.pow(Y - linearmodel, 2))
learningrate = 0.01

print("set Optimizer")
trainoperation = tf.train.GradientDescentOptimizer(learningrate).minimize(lossfunc)

sess = tf.Session()
init = tf.global_variables_initializer()
sess.run(init)

print("caculation begins ...")
for j in range(100):
  for i in range(100):
    sess.run(trainoperation, feed_dict={X: xdata[i], Y:ydata[i]})
    #print("i = " + str(i) + "b: " + str(B.eval(session=sess)) + ", w : " + str(W.eval(session=sess)))
print("caculation ends ...")
print("##After Caculation: ") 
print("   B: " + str(B.eval(session=sess)) + ", W : " + str(W.eval(session=sess)))
print("   B: 2  W: 1 (Real Value)")
print("##Test for the trained model: Y = X*W + B")
testxdata       = 3.
expectydata     = testxdata*2 + 1
calculatedydata = W.eval(session=sess) * testxdata + B.eval(session=sess)
precision       = 100 - np.abs(calculatedydata/expectydata - 1) * 100
print("  X=%f , Y = ? (2*%f + 1 = %f)" %(testxdata,testxdata,expectydata))
print("  Y= %f, pricse = %f %%" %(calculatedydata,precision)) 

testxdata       = 10.
expectydata     = testxdata*2 + 1
calculatedydata = W.eval(session=sess) * testxdata + B.eval(session=sess)
precision       = 100 - np.abs(calculatedydata/expectydata - 1) * 100
print("  X=%f , Y = ? (2*%f + 1 = %f)" %(testxdata,testxdata,expectydata))
print("  Y= %f, pricse = %f %%" %(calculatedydata,precision)) 

plt.scatter(xdata,ydata)
plt.plot(xdata,B.eval(session=sess)+W.eval(session=sess)*xdata,'b',label='caculated : w*x + b')
plt.legend()
plt.show()
