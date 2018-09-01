#!/usr/bin/python3

import os
import sys
import collections
import json
import pickle
from blockchain_parser.blockchain import Blockchain
from blockchain_parser.script import *

BLOCKNET_PCH = b"\xa1\xa0\xa2\xa3"
BLOCKNET_TEST_PCH = b"\x45\x76\x65\xba"
BLOCKNET_TEST_VB = [b'\x8b', b'\x13']

class BalancePlugin:
    def __init__(self):
        try:
            f = open("txindex.pickle", "rb")
            self.txindex = pickle.load(f)
        except:
            self.txindex = {}
        try:
            f = open("balances.pickle", "rb")
            self.balances = pickle.load(f)
        except:
            self.balances = {}
        #self.blockchain = Blockchain(os.path.expanduser('~/bitcoin-data/blocks'))
        self.blockchain = Blockchain(os.path.expanduser('~/.blocknetdx/testnet4/blocks'), BLOCKNET_TEST_PCH)
            
    def dump(self):
        f = open("txindex.pickle", "wb")
        pickle.dump(self.txindex, f)
        f = open("balances.pickle", "wb")
        pickle.dump(self.balances, f)
        
    def scan_all(self, start=0, end=-1):
        stop = 0
        #for block in self.blockchain.get_ordered_blocks(os.path.expanduser('~/bitcoin-data/blocks/index')):
        for block in self.blockchain.get_unordered_blocks():
            stop = stop + 1
            if (end > 0) and (stop > end):
                break
            #print block
            if stop % 1000 == 0:
                print (stop)
            for transaction in block.transactions:
                self.txindex[transaction.hash] = {}
                output_i = 0
                for output in transaction.outputs:
                    self.txindex[transaction.hash][output_i] = [output.value, []]
                    for address in output.addresses:
                        addr = address.get_address(version_bytes=BLOCKNET_TEST_VB)
                        self.txindex[transaction.hash][output_i][1].append(addr)
                        if not addr in self.balances:
                            self.balances[addr] = output.value
                        else:
                            self.balances[addr] += output.value
                    output_i += 1
                for inp in transaction.inputs:
                    try:
                        tx = self.txindex[inp.transaction_hash][inp.transaction_index]
                        for address in tx[1]:
                            self.balances[address] -= tx[0]
                    except:
                        pass
        self.dump()
            

p = BalancePlugin()
#p.scan_all()
print(len(list(p.balances.keys())))
print(p.txindex['023932239b35a1e9a252eda1b3ac2b58dc02ba9df4baa2363bdc443b612c6512'])
print(p.balances['xyLmRZxgDhnHq9xbCtV6HQQLNCDMxzJKbz'] / 100000000.0)
'''for k in p.balances:
    if p.balances[k] > 1000000000000:
        print (k, p.balances[k] / 100000000.0)'''