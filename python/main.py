import numpy as np
from plotting import plotTimeSeries
from cubli import CubliV1


def main():
    Lt: float = 0.085
    cubli = CubliV1(params={
        'Lt': Lt,
        'M': 0.419,
        'g': 9.81,
        'Fw': 0.05e-3,
        'Fc': 1.02e-3,
        'If': 3.34e-3,
        'Iw': 0.57e-3,
        'Km': 1.0,
        'u': 0.0,
        'COM': Lt*np.sqrt(2)
    })
    t_start: float = 0.0
    t_end: float = 50.0
    dt: float = 1e-3
    x_0: np.ndarray = np.array([0.01, 0.0, 0.0, 0.0])

    x = cubli.run(t_start, t_end, dt, x_0)
    plotTimeSeries(x, dt)


if __name__ == '__main__':
    main()
