import numpy      as np
import matplotlib.pyplot as plt

xdata = np.linspace(0,1,100)
ydata = 2 * xdata + np.random.rand(*xdata.shape)*0.2 + 1

plt.subplot(1,2,1)
plt.scatter(xdata,ydata,color='b')
plt.title('noise: random.rand')

plt.subplot(1,2,2)
plt.hist(ydata,20)
plt.title('distribution: random')
plt.show()

