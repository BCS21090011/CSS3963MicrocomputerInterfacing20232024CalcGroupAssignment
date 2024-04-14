def Swap(arr: list, index1: int, index2: int) -> list:
	retArr: list = arr.copy()

	tmp = retArr[index1]
	retArr[index1] = retArr[index2]
	retArr[index2] = tmp

	return retArr

def BubbleSort(arr: list) -> list:
	Arr: list = arr.copy()
	
	for cI in range(len(Arr)-1):
		for nI in range(cI+1, len(Arr)):
			if Arr[nI] < Arr[cI]:
				Arr = Swap(Arr, cI, nI)
	return Arr
