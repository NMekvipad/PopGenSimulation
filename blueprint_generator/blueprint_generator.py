import regex as re
import numpy as np

def get_sfsname(sfs_path):

    '''get the name of sfs file from input path to sfs file'''

    with open(sfs_path, 'r') as sfs_file:
        name_wext = sfs_file.name

    name = re.findall(r'(.*)_DAFpop0.obs', name_wext)[0]

    return name

def get_sfslist(sfs_path):

    '''get sfs of all replicates from input path to sfs file'''

    sfs_list = list()
    sam_sfs=np.loadtxt(sfs_path, skiprows=2)
    for row in sam_sfs:
        sfs_list.append('\t'.join(str(int(val)) for val in list(row[1:-1])))

    return sfs_list

def get_seqlen(sfs_path):

    '''get total length of sequence from sfs file'''

    sam_sfs=np.loadtxt(sfs_path, skiprows=2)[0, :]

    return int(np.sum(sam_sfs))

def get_nseq(sfs_path):

    '''get total number of sequence from sfs file'''

    sam_sfs = np.loadtxt(sfs_path, skiprows=2)[0, :]

    return sam_sfs.shape[0] - 1


def blueprint_generator(sfs_path, stairway_path='../stairway_software/stairway_plot_v2/stairway_plot_es', fold='false',
                        n_bootstrap='200', pct_training='0.67', mut_rate='1.2e-8', len_gen='25'):

    '''create blueprint file for stairway plot from sfs file
        The 2 main input are
            1) the path to sfs file (_DAFpop0.obs file from fasimcoal)
            2) the path from blueprint file to stairway_plot_es folder
    '''

    sfs_name = get_sfsname(sfs_path)

    seq_len = get_seqlen(sfs_path)

    seq_count = get_nseq(sfs_path)

    sfs_list = get_sfslist(sfs_path)

    n_rand = '\t'.join([str(round((seq_count-2)/4)), str(round((seq_count-2)/2)),
                        str(round((seq_count-2)*3/4)), str(round((seq_count-2)))])

    for idx, sfs in enumerate(sfs_list):
        write_out = ['popid: {}'.format(sfs_name), 'nseq: {}'.format(str(seq_count)), 'L: {}'.format(seq_len),
                     'whether_folded: {}'.format(fold), 'SFS: {}'.format(sfs), 'pct_training: {}'.format(pct_training),
                     'nrand: {}'.format(n_rand), 'project_dir: {}'.format(sfs_name),
                     'stairway_plot_dir: {}'.format(stairway_path), 'ninput: {}'.format(n_bootstrap),
                     'mu: {}'.format(mut_rate), 'year_per_generation: {}'.format(len_gen),
                     'plot_title: {}'.format(sfs_name),
                     'xrange: 0.1,10000\nyrange: 0,0\nxspacing: 2\nyspacing: 2\nfontsize: 12']

        with open('{}-{}.blueprint'.format(sfs_name, idx+1), 'w') as outfile:
            outfile.write('\n'.join(write_out))

blueprint_generator('test_DAFpop0.obs')






