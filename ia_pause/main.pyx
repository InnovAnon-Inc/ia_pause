#! /usr/bin/env python
# cython: language_level=3
# distutils: language=c++

""" Pause for a Moment """

import asyncio
import os
from typing                                  import List, Optional, Iterable
from typing                                  import ParamSpec

from progress.bar                            import Bar
from structlog                               import get_logger

P     :ParamSpec = ParamSpec('P')
logger           = get_logger()

##
#
##

async def tick(bar:Bar, interval:float,)->None:
	bar.next()
	await asyncio.sleep(interval,)

async def _main(message:str='Momentarily Paused', max_value:int=10, wait_time:float=3,)->None:
	assert (max_value > 0)
	assert (wait_time > 0)
	interval:float = wait_time / float(max_value)
	assert (interval  > 0)
	with Bar(message, max=max_value,) as bar:
		for i in range(max_value):
			await tick(bar=bar, interval=interval,)		

def main()->None:
	message  :str   =     os.getenv('PAUSE_MESSAGE', 'Waiting for you to come to your senses')
	max_value:int   = int(os.getenv('PAUSE_COUNT',   '10'))
	wait_time:float = int(os.getenv('PAUSE_TIMER',    '3'))
	asyncio.run(_main(
		message=message,
		max_value=max_value,
		wait_time=wait_time,
	))
	logger.info('Proceeding')

if __name__ == '__main__':
	main()

__author__:str = 'you.com' # NOQA
