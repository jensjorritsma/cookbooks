#!/bin/sh

CLUSTERNAME=demo
MASTERDBNAME=rpx
SLAVEDBNAME=rpx
MASTERHOST=db01
SLAVEHOST=db02
REPLICATIONUSER=slony
REPLICATIONPASS=PG3l3f@nt

slonik <<_EOF_
    #--
    # define the namespace the replication system uses in our example it is
    # slony_example
    #--
    cluster name = $CLUSTERNAME;

    #--
    # admin conninfo's are used by slonik to connect to the nodes one for each
    # node on each side of the cluster, the syntax is that of PQconnectdb in
    # the C-API
    # --
    node 1 admin conninfo = 'dbname=$MASTERDBNAME host=$MASTERHOST user=$REPLICATIONUSER password=$REPLICATIONPASS';
    node 2 admin conninfo = 'dbname=$SLAVEDBNAME host=$SLAVEHOST user=$REPLICATIONUSER password=$REPLICATIONPASS';

    #--
    # init the first node.  Its id MUST be 1.  This creates the schema
    # _$CLUSTERNAME containing all replication system specific database
    # objects.

    #--
    init cluster ( id=1, comment = 'Master Node');

    #--
    # Slony-I organizes tables into sets.  The smallest unit a node can
    # subscribe is a set.  The following commands create one set containing
    # all 4 pgbench tables.  The master or origin of the set is node 1.
    #--
    create set (id=1, origin=1, comment='All pgbench tables');
    set add table (set id=1, origin=1, id=1, fully qualified name = 'public.ttd', comment='things to do table');
    #set add table (set id=1, origin=1, id=2, fully qualified name = 'public.branches', comment='branches table');
    #set add table (set id=1, origin=1, id=3, fully qualified name = 'public.tellers', comment='tellers table');
    #set add table (set id=1, origin=1, id=4, fully qualified name = 'public.history', comment='history table');

    #--
    # Create the second node (the slave) tell the 2 nodes how to connect to
    # each other and how they should listen for events.
    #--

    store node (id=2, comment = 'Slave node', event node=1);
    store path (server = 1, client = 2, conninfo='dbname=$MASTERDBNAME host=$MASTERHOST user=$REPLICATIONUSER password=$REPLICATIONPASS');
    store path (server = 2, client = 1, conninfo='dbname=$SLAVEDBNAME host=$SLAVEHOST user=$REPLICATIONUSER password=$REPLICATIONPASS');
_EOF_

