import credstash


def load_arguments():
    DATANYM_POSTGRES_USER = credstash.getSecret(f'database.aws_rds_cluster.datanym-postgres.user', region='us-east-1',
                                                 profile_name='codenym')
    DATANYM_POSTGRES_PASSWORD = credstash.getSecret(f'database.aws_rds_cluster.datanym-postgres.password',
                                                     region='us-east-1', profile_name='codenym')

    args = f"-var 'DATANYM_POSTGRES_USER={DATANYM_POSTGRES_USER}'"
    args += f" -var 'DATANYM_POSTGRES_PASSWORD={DATANYM_POSTGRES_PASSWORD}'"
    return args
