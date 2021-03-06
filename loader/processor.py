#!/usr/bin/env python3

import sys
import psycopg2
import scraper
import database

""" Loads and processes all data related to block with given number """
def process_block(block_number):
    b = scraper.load_block(block_number)
    try:
        database.save_block(b)
    except psycopg2.IntegrityError:
        print("Block <{}> already loaded".format(block_number))

    for tx_hash in b["transactions"]:
        tx = scraper.load_transaction(tx_hash)
        try:
            database.save_transaction(tx)
        except psycopg2.IntegrityError:
            print("Transaction <{}> already loaded".format(tx_hash))

""" Processes blocks as per CLI args """
def process():
    if len(sys.argv) != 3:
        print("Pass block number and number of blocks as arguments")
        return

    block_number = int(sys.argv[1])
    blocks = int(sys.argv[2])
    
    for i in range(0, blocks):
        process_block(block_number + i)
        print("Processed block <{}>".format(block_number + i))

process()
