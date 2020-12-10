import numpy as np
from matplotlib import pyplot as plt
from numpy import pi


class Cubli:
    params = {
        'Lt': 0.085,
        'M': 0.419,
        'g': 9.81,
        'Fw': 0.05e-3,
        'Fc': 1.02e-3,
        'If': 3.34e-3,
        'Iw': 0.57e-3,
        'Km': 1.0,
        'u': 0.0
    }
    params['COM'] = params['Lt']*np.sqrt(2)

    def iterate(self, x):
        x_dot = np.zeros(4)
        x_dot[0] = x[2]
        x_dot[1] = x[3]

        x_dot[2] = (self.params['Lt']*self.params['M']*self.params['g']*np.sin(x[0])) - self.params['u'] + self.params['Fw']*x[3] - self.params['Fc']*x[2]/self.params['If']

        x_dot[3] = (self.params['u']*(self.params['If'] + self.params['Iw']) - \
                   self.params['Fw']*x[3]*(self.params['If'] + self.params['Iw']) - \
                   self.params['Lt']*self.params['M']*self.params['g']*np.sin(x[0])*self.params['Iw'] + \
                   self.params['Fc']*x[2]*self.params['Iw'])/(self.params['If']*self.params['Iw'])
        return x_dot


def main():
    cubli = Cubli()
    print(cubli.params)
    t_start = 0
    t_end = 50
    dt = 1e-3
    N_iter = int((t_end - t_start)/dt)

    initial_condition = (0.01, 0.0, 0.0, 0.0)

    x = np.zeros((N_iter, 4))
    x[0] = initial_condition
    for i in range(1, N_iter):
        x[i] = x[i-1] + dt * cubli.iterate(x[i-1])
    print(x)
    plt.plot(x[:, 0])
    plt.show()


if __name__ == '__main__':
    main()
