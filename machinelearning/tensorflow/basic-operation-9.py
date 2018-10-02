import tensorflow as tf
import numpy      as np
import os
import matplotlib.pyplot as plt

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

xdata = np.linspace(0,1,100)
ydata = 2 * xdata + np.random.rand(*xdata.shape) + 1
plt.scatter(xdata,ydata,color='b')
plt.title('noise: random.rand')
plt.show()

plt.hist(ydata,20)
plt.title('distribution: random')
plt.show()

