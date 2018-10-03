import matplotlib.pyplot as plt
from linearmodel import LinearModel

model = LinearModel()
model.load(2,3)
(B,W) = model.train()
plt.scatter(model.xdata,model.ydata)
plt.plot(model.xdata,model.xdata*W + B, 'r', label='xxxx')
plt.show()
