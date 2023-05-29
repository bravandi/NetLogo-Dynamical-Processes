import networkx as nx
import matplotlib.pyplot as plt
from collections import defaultdict
import numpy as np
import os
import random
import time
from tqdm import tqdm
from itertools import combinations
import pandas as pd
from sklearn.linear_model import LinearRegression
import matplotlib as mpl
import datetime
import math
from scipy.stats import norm, kurtosis, mode

# cmap = plt.get_cmap('tab10')
from scipy.stats import describe
import seaborn as sns
from matplotlib.pyplot import figure
import pickle
import concurrent.futures
import datetime


def one_simulation(p_out, G_input, N_walkers, initial_node_with_walkers, run_time, path_g):
    end_time_list = []
    r_square_re = []
    for iter_num in range(run_time):
        current_datetime = datetime.datetime.now()
        time_str = current_datetime.strftime("%H:%M:%S %m/%d/%Y")
        print('  [one_simulation {} | iter_num: {}] {}'.format(time_str, iter_num, path_g))
        # G = G_ba.copy()
        G = G_input.copy()
        N_nodes = len(G.nodes())

        ### Asign the walker
        nx.set_node_attributes(G, [0], 'history')
        initial_walkers = random.sample(range(N_nodes), initial_node_with_walkers)
        for i in initial_walkers:
            G.nodes[i]['history'] = [N_walkers / initial_node_with_walkers]

        degree_of_initial = [G.degree(k) for k in initial_walkers]

        # the x (expected final distribution of walkers) of the linear regression
        walker_per_degree = N_walkers / sum([j for (i, j) in G.degree])
        degree_list = np.array([j * walker_per_degree for (i, j) in G.degree])
        degree_list = degree_list.reshape(-1, 1)

        # Run the simulation model until the R-square over 0.99
        linear_score = [0]
        end_time = 0
        while linear_score[-1] < 0.99:
            end_time += 1
            for nodes in G.nodes:
                tem_out_list = [n for n in G.neighbors(nodes)]
                tem_in_node = 0
                for neigh_node in tem_out_list:
                    tem_in_node += G.nodes[neigh_node]['history'][end_time - 1] * p_out / len(
                        [n for n in G.neighbors(neigh_node)])
                G.nodes[nodes]['history'] = G.nodes[nodes]['history'] + [
                    tem_in_node + G.nodes[nodes]['history'][end_time - 1] * (1 - p_out)]
            ## Run the linear regression
            check_list = []
            for nodes in G.nodes:
                check_list.append(G.nodes[nodes]['history'][-1])
            reg = LinearRegression().fit(degree_list, check_list)
            linear_score.append(round(reg.score(degree_list, check_list), 4))
        # record the end time of each simulation
        end_time_list.append(end_time)

    return end_time_list


def task(path_g):
    p_out = 0.4
    N_walkers = 10000
    initial_node_with_walkers = 4
    run_time = 100

    path_end_time = 'res/' + path_g.split('/')[1] + '_endtime.npy'

    if os.path.exists(path_end_time):
        current_datetime = datetime.datetime.now()
        time_str = current_datetime.strftime("%H:%M:%S %m/%d/%Y")
        print('[EXISTS | {}] {}'.format(time_str, path_end_time))
        return

    current_datetime = datetime.datetime.now()
    time_str = current_datetime.strftime("%H:%M:%S %m/%d/%Y")
    print('[WORKING ON GRAPH | {}] {}'.format(time_str, path_g))

    G_ER_total = nx.read_gpickle(path_g)

    Gcc = sorted(nx.connected_components(G_ER_total), key=len, reverse=True)
    G_ER = G_ER_total.subgraph(Gcc[0])

    if G_ER_total.number_of_nodes() != G_ER.number_of_nodes():
        print('N(G_ER_total): {} | N(G_ER): {}'.format(G_ER_total.number_of_nodes(), G_ER.number_of_nodes()))
    # print(G_ER.number_of_nodes())

    end_time_list_ER = one_simulation(p_out, G_ER, N_walkers, initial_node_with_walkers, run_time, path_g)

    np.save(path_end_time, end_time_list_ER)

    current_datetime = datetime.datetime.now()
    time_str = current_datetime.strftime("%H:%M:%S %m/%d/%Y")
    print('[DONE! SAVED | {}] {}'.format(time_str, path_end_time))

    pass


if __name__ == '__main__':

    k_avg_list = [
        # 1,1.5,2,2.5,3,3.5,
        4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9, 9.5, 10
    ]

    '''
    Get All graphs
    '''
    all_g_path = []

    for k_avg in tqdm(k_avg_list):
        for _ in range(100):  ## 100 graph instances
            path_g = 'data/5a-ER-k_avg' + str(k_avg) + 'instance-' + str(_) + '.pickle'
            if os.path.exists(path_g) is False:
                raise Exception('path_g does not exists: {}'.format(path_g))
                pass

            all_g_path.append(path_g)

            pass
        pass

    print('Num graphs:', len(all_g_path))

    '''
    Run in parallel
    '''

    # Set the maximum number of workers
    max_workers = 400

    # Create a thread pool executor with the specified maximum workers
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
        # Submit tasks to the executor
        for p in all_g_path[0: 100]:
            executor.submit(task, p)

    print("All threads have completed")
