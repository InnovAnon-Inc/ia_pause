#! /usr/bin/env python
# cython: language_level=3
# distutils: language=c++

""" Pause for a Moment """

import asyncio
import os
from typing                                  import List, Optional, Iterable

from progress.bar                            import Bar
from structlog                               import get_logger

logger           = get_logger()

##
#
##

async def tick(bar:Bar, interval:float,)->None:
	bar.next()
	await asyncio.sleep(interval,)

async def ticker(message:str, max_value:int, interval:float,)->None:
	with Bar(message, max=max_value,) as bar:
		for i in range(max_value):
			await tick(bar=bar, interval=interval,)		

async def _main(message:str='Momentarily Paused', max_value:int=20, wait_time:float=5,)->bool:
	assert (max_value > 0)
	assert (wait_time > 0)
	interval:float = wait_time / float(max_value)
	assert (interval  > 0)
	try:
		await ticker(message:str, max_value:int, interval:float,)
		return True
	except KeyboardInterrupt as error:
		await logger.aerror(error)
		return False

def main()->None:
	message  :str   =     os.getenv('PAUSE_MESSAGE', 'Waiting for you to come to your senses')
	max_value:int   = int(os.getenv('PAUSE_COUNT',   '20'))
	wait_time:float = int(os.getenv('PAUSE_TIMER',    '5'))
	result   :bool  = asyncio.run(_main(
		message=message,
		max_value=max_value,
		wait_time=wait_time,
	))
	if result:
		logger.info('Proceeding')
	else:
		logger.info('Terminated')

if __name__ == '__main__':
	main()

__author__:str = 'you.com' # NOQA
