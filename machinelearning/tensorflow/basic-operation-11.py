import numpy      as np
import matplotlib.pyplot as plt

xdata = np.linspace(0,1,100)
ydata = 2 * xdata + np.random.rand(*xdata.shape)*0.2 + 1
yndata = 2 * xdata + 1 + np.random.normal(20,6,100)*0.02 
#yndata = 2 * xdata + 1 + np.random.normal(0,1,100)*0.2 

plt.subplot(2,2,1)
plt.scatter(xdata,ydata,color='b')
plt.title('noise: random.rand')

plt.subplot(2,2,2)
plt.hist(ydata,40)
plt.title('distribution: random')

plt.subplot(2,2,3)
plt.scatter(xdata,yndata,color='g')
plt.title('noise: random.randn')

plt.subplot(2,2,4)
plt.hist(yndata,40)
plt.title('distribution: normal')

plt.show()

