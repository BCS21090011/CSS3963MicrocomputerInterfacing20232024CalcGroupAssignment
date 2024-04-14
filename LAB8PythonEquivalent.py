class LAB8:
    def __init__(self, mem: list):
        # Initialize:

        self.SI: int = 0
        self.DI: int = 0
        self.AX: int = 0
        self.BX: int = 0
        self.CX: int = 0
        self.DX: int = 0

        self.MEM: list = mem
        self.ARRAY_BEG: int = 0
        self.ARRAY_END: int = len(self.MEM) - 1

        # Codes:
        
        self.SI = self.ARRAY_BEG
        self.BX = self.ARRAY_END
        
        # To mimic how assembly flow:
        self.AA()
    
    def AA (self):
        # Two indexes, SI is pointing to current data and DI is pointing to next data:
        self.DI = self.SI
        self.DI += 1
        
        # To mimic how assembly flow:
        self.BB()

    def BB (self):
        self.AX = self.MEM[self.SI]
        if self.AX <= self.MEM[self.DI]:	# if MEM[SI] <= MEM[DI]:
            # Skip swap:
            self.CC()
        else:
            # Swap MEM[SI] and MEM[DI]:
            self.DX = self.MEM[self.DI]
            self.MEM[self.SI] = self.DX
            self.MEM[self.DI] = self.AX
        
            # To mimic how assembly flow:
            self.CC()

    def CC (self):
        # Loop and compare every data with current MEM[SI]:
        self.DI += 1
        if self.DI <= self.BX:
            self.BB()
        else:
            # Loop, change SI, and compare again, data before MEM[SI] are sorted:
            self.SI += 1
            
            if self.SI < self.BX:
                self.AA()
            else:
                # To mimic how assembly flow:
                self.DONE()

    def DONE (self):
        return