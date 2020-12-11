import numpy as np
from typing import Dict


class CubliBase:
    def __init__(self, params=None) -> None:
        if params is not None:
            self.setParams(params)

    def setParams(self, params: Dict[str, float]) -> None:
        self.params: Dict[str, float] = params

    # Pure virtual function, must be implemented in derived classes
    def iterate(self, x) -> np.ndarray:
        pass

    def run(self, t_start: float, t_end: float, dt: float, x_0: np.ndarray) -> np.ndarray:
        N_iter: int = int((t_end - t_start)/dt)
        x: np.ndarray = np.zeros((N_iter, 4))
        x[0] = x_0  # Set initial conditions
        for i in range(1, N_iter):  # Iterate through time
            x[i] = x[i-1] + dt * self.iterate(x[i-1])
        return x


class CubliV1(CubliBase):
    def iterate(self, x) -> np.ndarray:
        x_dot: np.ndarray = np.zeros(4)
        x_dot[0] = x[2]
        x_dot[1] = x[3]

        x_dot[2] = (self.params['Lt']*self.params['M']*self.params['g']*np.sin(x[0])) - self.params['u'] + self.params['Fw']*x[3] - self.params['Fc']*x[2]/self.params['If']

        x_dot[3] = (self.params['u']*(self.params['If'] + self.params['Iw']) - \
                   self.params['Fw']*x[3]*(self.params['If'] + self.params['Iw']) - \
                   self.params['Lt']*self.params['M']*self.params['g']*np.sin(x[0])*self.params['Iw'] + \
                   self.params['Fc']*x[2]*self.params['Iw'])/(self.params['If']*self.params['Iw'])
        return x_dot
