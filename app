import plotly.graph_objects as go

# 1. 軸の設定（カテゴリ名）
categories = ['軸1', '軸2', '軸3', '軸4', '軸5', '軸6', '軸7']

# 2. 各データの数値
# 各リストの最後に最初の値をリピートすることで、チャートを閉じます。
data_A = [30, 40, 20, 35, 25, 30, 30]
data_B = [20, 30, 40, 15, 30, 45, 20]
data_C = [40, 20, 25, 45, 20, 10, 40]
data_D = [15, 25, 35, 20, 40, 30, 15]

fig = go.Figure()

# 3. データの追加（画像に近い色を設定）
def add_trace(fig, name, data, color):
    fig.add_trace(go.Scatterpolar(
        r=data + [data[0]],  # グラフを閉じるために先頭データを末尾に追加
        theta=categories + [categories[0]],
        fill='toself',       # 塗りつぶし設定
        name=name,
        line=dict(color=color, width=2),
        opacity=0.6          # 透過度の設定
    ))

# カラーコードは画像のイメージに合わせて調整
add_trace(fig, 'A', data_A, '#45B39D') # ティール系
add_trace(fig, 'B', data_B, '#5DADE2') # ブルー系
add_trace(fig, 'C', data_C, '#F4B400') # オレンジ系
add_trace(fig, 'D', data_D, '#AED6F1') # ライトブルー系

# 4. レイアウトの調整
fig.update_layout(
    polar=dict(
        radialaxis=dict(
            visible=True,
            range=[0, 50], # 軸の最大値
            gridcolor='lightgray',
        ),
        angularaxis=dict(
            gridcolor='lightgray',
        ),
        bgcolor='white'
    ),
    showlegend=True,
    legend=dict(orientation="h", yanchor="bottom", y=-0.2, xanchor="center", x=0.5), # 凡例を下に配置
    margin=dict(l=50, r=50, t=50, b=50),
    paper_bgcolor="white"
)

fig.show()