from matplotlib import pyplot as plt
import numpy as np


def plotTimeSeries(x: np.ndarray, dt: float) -> None:
    t: np.ndarray = np.linspace(0, dt*len(x), len(x))
    fig, ax = plt.subplots(nrows=4, ncols=1)
    for i in range(4):
        ax[i].plot(t, x[:, i])
        ax[i].set_ylabel(r"$x_{}$".format(i))
    ax[3].set_xlabel("Time (s)")
    plt.show()
