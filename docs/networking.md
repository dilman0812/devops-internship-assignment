# Networking Setup

## VPC

CIDR:
10.0.0.0/16

## Public Subnet

CIDR:
10.0.1.0/24

Purpose:
Hosts API gateway VM.

## Private Subnet

CIDR:
10.0.2.0/24

Purpose:
Hosts inference worker VM.

## Internet Gateway

Attached to VPC.

## Public Route Table

0.0.0.0/0 -> Internet Gateway

Associated:
public-subnet

## Private Route Table

Local routing only.

Associated:
private-subnet

## Security Goal

Only API VM accessible publicly.

Inference VM isolated inside private subnet.
