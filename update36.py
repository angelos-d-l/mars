from sqlalchemy import create_engine
import pandas as pd

sql_select = "SELECT * FROM search2"
engine = create_engine('mysql+pymysql://antimeteo:2392lampiriS@db56.grserver.gr:3306/FORECASTS?charset=utf8')

ll_table = pd.read_sql(sql_select, engine)
new_table = pd.read_table('./weatherspot.txt',  header=None)

new_table.columns = ['ID' , 'HOURSinced', 'T2m', 'RH', 'Wind_intensity', 'Wind_dir', 'WT']
new_df = pd.merge(ll_table,new_table, how='left', on=['ID', 'HOURSinced'])

new_df['T2m'] = new_df['T2m_y'].fillna(new_df['T2m_x']).astype(int)
new_df['RH'] = new_df['RH_y'].fillna(new_df['RH_x']).astype(int)
new_df['Wind_intensity'] = new_df['Wind_intensity_y'].fillna(new_df['Wind_intensity_x']).astype(int)
new_df['Wind_dir'] = new_df['Wind_dir_y'].fillna(new_df['Wind_dir_x']).astype(int)
new_df['WT'] = new_df['WT_y'].fillna(new_df['WT_x']).astype(int)

final = new_df.drop(['T2m_y', 'T2m_x', 'RH_y', 'RH_x', 'Wind_intensity_y',
            'Wind_intensity_x', 'Wind_dir_y', 'Wind_dir_x',
             'WT_y', 'WT_x'] , axis=1)

final.to_csv('./weather2.txt', sep='\t', index=False, header=False)
